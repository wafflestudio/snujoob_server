var JoinSection = React.createClass({
  join: function(){
    var s = this.refs.studentId.value
    var p = this.refs.password.value
    var c = this.refs.passwordConfirm.value
    var pattern = /20[0-9]{2}-[12][0-9]{4}/;
    if (s === '' || p === '' || p !== c || !pattern.test(s)){
      System.setMessage('입력하신 정보를 확인해주세요')
      return;
    }
    var params = {'student_id': s, 'password': p}
    $.ajax({
      url: '/join',
      type: 'post',
      contentType: 'application/json',
      data: JSON.stringify(params),
      dataType: 'json',
    }).done(function(data){
      if (data.result){
        System.setMessage('회원가입에 성공하셨습니다')
      } else {
        System.setmessage('회원가입에 실패하셨습니다 ' + data.message)
      }
    })
  },
  render: function(){
    return (
      <section>
        <p>회원가입하기 <a target=".blank" href="http://glglgozz.snucse.org/snujoob">설명은 이곳에서</a></p>
        <div>
          <input ref="studentId" placeholder="2015-xxxxx" />
        </div>
        <div>
          <input ref="password" placeholder="password" type="password" />
        </div>
        <div>
          <input ref="passwordConfirm" placeholder="password (again)" type="password" />
        </div>
        <div>
          <button onClick={this.join}>join</button>
        </div>
      </section>
    );
  }
});
