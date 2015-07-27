#coding:utf-8

#수강편람을 긁어옴
#인자 : year semester
require 'net/http'
require 'roo'
require 'roo-xls'
require 'json'

if ARGV.length != 2 then
  puts "Argument error !"
  puts "usage example : ruby fetch.rb 2012 S"
  exit!
end
year = ARGV[0]
semester = ARGV[1] #1/S/2/W

if !(year.to_i > 2000) then
  puts "First argument should be year"
  exit!
elsif !["1", "2", "S", "W"].include?(semester) then
  puts "Second argument should be in [1, 2, S, W]"
  exit!
end

#download 
puts "Start fetching...#{year}/#{semester}"

xls_filename="#{Dir.getwd()}/xls/#{year}_#{semester}.xls"
txt_filename="#{Dir.getwd()}/txt/#{year}_#{semester}.txt"

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

open(xls_filename,"w") do |file|
  file.print(res.body)
end
puts "download complete : #{year}_#{semester}.xls"

#convert
puts "start converting from xls to txt"
excel = Roo::Excel.new(xls_filename);
m = excel.to_matrix

open("#{txt_filename}.tmp", "w") do |file|
  #file.puts "#{year}/#{semester}"
  #file.puts Time.now.localtime().strftime("%Y-%m-%d %H:%M:%S")
  #file.puts "subject_name;subject_number;lecture_number;lecturer;capacity;enrolled"
  4.upto(m.row_size-1) do |i|
    classification = m[i,0]
    department = m[i,2]
    academic_year = m[i,3]
    if academic_year == "학사"
      academic_year = m[i,4]
    end
    course_number = m[i,5]
    lecture_number = m[i,6]
    course_title = m[i,7]
    if m[i,8].to_s.length > 1
      course_title = course_title + "(#{m[i,8]})"
    end
    course_title = course_title.gsub(/;/, ':').gsub(/\"/, '\'')
    credit = m[i,9].to_i
    class_time = m[i,12]
    location = m[i,14]
    instructor = m[i,15]
    quota = m[i,16].split(" ")[0].to_i
    quota_enrolled = nil
    if m[i,15].index('(')
      quota_enrolled = m[i,15][m[i,15].index('(')+1..-1].to_i
    end
    enrollment = m[i,17].to_i
    remark = m[i,18].gsub(/
\n/, " ")
    snuev_lec_id = snuev_eval_score = nil

    index = course_number + lecture_number
    a = 0
    index.split('').each_with_index do |c, y|
      a += c.ord * 10 ** y
    end
    file.puts "#{a % 2147483647};#{course_title};#{course_number};#{lecture_number};#{instructor};#{quota};#{enrollment};;;#{quota_enrolled}"
  end
end
