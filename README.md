# SNUJoob v2.0.0

## 루비 버전

Ruby 2.2.4p240

## 실행

    bundle install
    rake db:migrate
    whenever -w

그리고 30초 이내로 일어난다면 crontab을 열어서

    crontab -e

내용을 다음과 같이 수정한다

    * * * * * /bin/bash -l -c 'cd /home/glglgozz/snujoob_server && bin/rails runner -e development '\''fetch/fetch.rb'\'' && bin/rails runner -e development '\''fetch/fetch.rb'\'''

## 환경설정

    ruby fetch/setting.rb
    vi config/gcm_api_key.yml
