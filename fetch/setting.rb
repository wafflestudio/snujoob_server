require 'yaml'

begin
  system 'touch config/snujoob.yml'
  print 'year (20xx): '
  year = gets.to_i
  print 'semester (in 1/2/S/W):'
  semester = gets.to_i
  puts '세번째 날이란 짝홀이 끝난 후의 혼란의 날을 의미합니다'
  print 'third day (20xx-xx-xx): '
  third_day_in = gets
  third_day = DateTime.strptime("#{third_day_in} +09", '%Y-%m-%d %z')
  puts '자유로운 날이란 새내기와의 차별없이 모든 학생이 변경을 할 수 있는 날을 의미합니다. 대개 개학일입니다'
  print 'free day (20xx-xx-xx): '
  free_day_in = gets
  free_day = DateTime.strptime("#{free_day_in} +09", '%Y-%m-%d %z')

  snujoob = {"year" => year, "semester" => semester, "third_day" => third_day.strftime('%Y-%m-%d %z'), "free_day" => free_day.strftime('%Y-%m-%d %z')}
  yaml = File.open("config/snujoob.yml", "w")
  yaml.write(YAML::dump(snujoob))
  yaml.close
  puts '변경 완료'
rescue => e
  puts 'error', e.message
end
