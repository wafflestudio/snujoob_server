# SNUJoob v2.1.0

## 루비 버전

Ruby 2.2.4p240

## 시스템 디펜던시

레디스 설치

## 실행

    bundle install
    rake db:migrate
    whenever -w

그리고 30초 이내로 일어난다면 crontab을 열어서

    crontab -e

내용을 다음과 비슷하게 적당히 수정한다

    * * * * * /bin/bash -l -c 'cd [rails root] && bin/rails runner -e development '\''fetch/fetch.rb'\'' && bin/rails runner -e development '\''fetch/fetch.rb'\'''

## 환경설정
다음을 실행하여 업데이트 받을 년도와 학기를, 수강신청 날짜들을 설정한다

    ruby fetch/setting.rb

그러면 `config/snujoob.yml`이 생성된다.  
`config/gcm_api_key.yml.example`을 참고하여 다음을 작성한다.

    vi config/gcm_api_key.yml

레디스에 비밀번호가 걸려있다면 다음을 추가한다

    $ vi config/initializers/websocket_rails.rb

    config.redis_options = {host: 'your.host', port: '6379', password: [password]}

`app/assets/javascripts/homepage.js`에서 웹소켓에 서비스할 호스트를 고친다... 나중에 고치겠다
