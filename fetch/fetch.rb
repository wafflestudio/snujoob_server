#coding:utf-8

#수강편람을 긁어옴
#인자 : year semester
require 'net/http'
require 'roo'
require 'roo-xls'
require 'json'
require 'digest/sha1'
require 'yaml'

init_time = `date +%s.%N`.to_f
snujoob = YAML::load_file("config/snujoob.yml")||{}
year = snujoob["year"]
semester = snujoob["semester"] #1/S/2/W

if !(year.to_i > 2010) then
  puts "First argument should be year"
  exit!
elsif ![1, 2, "1", "2", "S", "W"].include?(semester) then
  puts "Second argument should be in [1, 2, S, W]"
  exit!
end

#download
puts "Start fetching #{year}/#{semester}"

xls_filename="#{Rails.root}/fetch/#{year}_#{semester}.xls"

http = Net::HTTP.new('sugang.snu.ac.kr', 80)
path="/sugang/cc/cc100excel.action"
case semester
when '1'
  shtm = 'U000200001U000300001'
  shtm2 = '1학기'
when '2'
  shtm = 'U000200002U000300001'
  shtm2 = '여름학기'
when 'S'
  shtm = 'U000200001U000300002'
  shtm2 = '2학기'
when 'W'
  shtm = 'U000200002U000300002'
  shtm2 = '겨울학기'
end
data = "srchCond=1&pageNo=1&workType=EX&sortKey=&sortOrder=&srchOpenSchyy=#{year}&currSchyy=#{year}&srchOpenShtm=#{shtm}&srchCptnCorsFg=&srchOpenShyr=&srchSbjtCd=&srchSbjtNm=&srchOpenUpSbjtFldCd=&srchOpenSbjtFldCd=&srchOpenUpDeptCd=&srchOpenDeptCd=&srchOpenMjCd=&srchOpenSubmattFgCd=&srchOpenPntMin=&srchOpenPntMax=&srchCamp=&srchBdNo=&srchProfNm=&srchTlsnAplyCapaCntMin=&srchTlsnAplyCapaCntMax=&srchTlsnRcntMin=&srchTlsnRcntMax=&srchOpenSbjtTmNm=&srchOpenSbjtTm=&srchOpenSbjtTmVal=&srchLsnProgType=&srchMrksGvMthd="
res, data = http.post(path, data)

open(xls_filename,"wb") do |file|
  file.write(res.body)
end
download_time = `date +%s.%N`.to_f
puts "#{year}_#{semester}.xls downloaded. elapsed time: #{download_time - init_time}s"

#update
puts "update lectures"
excel = Roo::Excel.new(xls_filename);
m = excel.to_matrix

4.upto(m.row_size-1) do |i|
  subject_number = m[i,5]
  lecture_number = m[i,6]
  name = m[i,7]
  if m[i,8].to_s.length > 1
    name = "#{name} (#{m[i,8]})"
  end
  time = m[i,12]
  lecturer = m[i,15]
  whole_capacity = m[i,16].split(" ")[0].to_i
  enrolled_capacity = 0
  if (j = m[i,16].index('('))
    enrolled_capacity = m[i,16][j+1..-1].to_i
  end
  enrolled = m[i,17].to_i

  id_string = Digest::SHA1.hexdigest(subject_number + lecture_number + lecture_number)
  id = id_string.to_i(16) % 2147483647 + 1
  begin
    lecture = Lecture.find id
    if lecture.enrolled != enrolled or lecture.lecturer != lecturer or lecture.time != time
      `echo '#{`date '+%Y-%m-%d %H:%M:%S'`.sub(/\n/, '')} update #{subject_number} #{lecture_number} #{name} #{lecture.enrolled} -> #{enrolled}' >> log/update.log`
      lecture.enrolled = enrolled
      lecture.lecturer = lecturer
      lecture.time = time
      lecture.save
    end
  rescue ActiveRecord::RecordNotFound => e
    Lecture.create({
      id: id,
      subject_number: subject_number,
      lecture_number: lecture_number,
      name: name,
      lecturer: lecturer,
      time: time,
      whole_capacity: whole_capacity,
      enrolled_capacity: enrolled_capacity,
      enrolled: enrolled,
    })
  rescue => e
    puts id
    puts subject_number
    puts lecture_number
    puts e
  end
end
puts "total elapsed time: #{`date +%s.%N`.to_f - init_time}s"
