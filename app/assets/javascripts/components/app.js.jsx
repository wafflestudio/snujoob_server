var Util = {
  setCookie: function(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
  },
  getCookie: function(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return "";
  },
}

var System = {
  message: '',
  setMessage: function(m){
    this.message = m;
  }
}

var socket = new WebSocketRails("leeingnyo.me:14000/websocket");
var chan = socket.subscribe('watch')

var App = React.createClass({
  /* - props
   * 
   * - state
   * isLogin
   * studentId
   * token
   * registeredList
   */
  getUserInfo: function(){
    var studentId = this.state.studentId
    var token = this.state.token
    $.ajax({
      beforeSend: function (xhr){
        xhr.setRequestHeader('x-user-token', token)
      },
      url: '/users/' + studentId,
      type: 'get',
      dataType: 'json'
    }).done(function (data){
      this.setState({registeredList: data.lectures})
    }.bind(this))
  },
  login: function(s, p){
    var pattern = /20[0-9]{2}-[12][0-9]{4}/;
    if (s === '' || p === '' || !pattern.test(s)){
      System.setMessage('아이디와 비밀번호를 확인해주세요')
      this.setState({isLogin: false})
    }
    var params = {'student_id': s, 'password': p}
    $.ajax({
      url: '/login',
      type: 'post',
      contentType: 'application/json',
      data: JSON.stringify(params),
      dataType: 'json',
    }).done(function(data){
      if (data.result){
        System.setMessage('')
        Util.setCookie('student_id', s, 7)
        Util.setCookie('token', data.token, 7)
        this.setState({
          studentId: s,
          token: data.token,
          isLogin: true,
        })
        this.getUserInfo()
      } else {
        System.setMessage('로그인에 실패했습니다')
        this.setState({isLogin: false})
      }
    }.bind(this))
  },
  autoLogin: function(){
    if (this.state.studentId === '' || this.state.token === ''){
      System.setMessage('로그인이 필요합니다')
      this.setState({isLogin: false})
    }
    var params = {'student_id': this.state.studentId}
    var token = this.state.token
    $.ajax({
      beforeSend: function (xhr){
        xhr.setRequestHeader('x-user-token', token)
      },
      url: '/auto_login',
      type: 'post',
      contentType: 'application/json',
      data: JSON.stringify(params),
      dataType: 'json',
    }).done(function (data){
      if (data.result){
        System.setMessage('')
        this.setState({isLogin: true})
        this.getUserInfo()
      } else {
        System.setMessage('로그인이 필요합니다')
        this.setState({isLogin: false})
      }
    }.bind(this))
  },
  logout: function(){
    Util.setCookie('student_id', '', 0)
    Util.setCookie('token', '', 0)
    this.setState({
      isLogin: false
    })
  },
  isRegistered: function(id){
    for (let i = 0; i < this.state.registeredList.length; i++){
      if (this.state.registeredList[i].id === id) return true
    }
    return false
  },
  getRegistered: function(id){
    for (let i = 0; i < this.state.registeredList.length; i++){
      if (this.state.registeredList[i].id === id) return this.state.registeredList[i]
    }
    return null
  },
  register: function(id){
    var params = {'lecture_id': id}
    var token = this.state.token
    var studentId = this.state.studentId
    $.ajax({
      beforeSend: function (xhr){
        xhr.setRequestHeader('x-user-token', token)
      },
      url: '/users/' + studentId + '/register',
      type: 'post',
      contentType: 'application/json',
      data: JSON.stringify(params),
      dataType: 'json',
    }).done(function (data){
      if (data.result){
        System.setMessage('강의를 등록했습니다')
        this.getUserInfo()
      } else {
        System.setMessage('실패')
      }
    }.bind(this))
  },
  deregister: function(id){
    var params = {'lecture_id': id}
    var token = this.state.token
    var studentId = this.state.studentId
    $.ajax({
      beforeSend: function (xhr){
        xhr.setRequestHeader('x-user-token', token)
      },
      url: '/users/' + studentId + '/unregister',
      type: 'post',
      contentType: 'application/json',
      data: JSON.stringify(params),
      dataType: 'json',
    }).done(function (data){
      if (data.result){
        System.setMessage('강의를 해제했습니다')
        this.getUserInfo()
      } else {
        System.setMessage('실패')
      }
    }.bind(this))
  },
  getInitialState: function(){
    return {
      studentId: Util.getCookie('student_id'),
      token: Util.getCookie('token'),
      registeredList: [],
      isLogin: false,
    }
  },
  componentDidMount: function(){
    if (this.isMounted()) {
      this.autoLogin()
    }
  },
  render: function(){
    var main = null;
    if (!this.state.isLogin){
      main = (
        <section>
          <LoginSection login={this.login} />
          <JoinSection />
        </section>
      )
    } else {
      main = (
        <section>
          <Notification isRegistered={this.isRegistered} chan={chan} getRegistered={this.getRegistered} />
          <h1>환영합니다 {this.state.studentId}</h1>
          <UserInforSection lectures={this.state.registeredList} manageLectures={{
            isRegistered: this.isRegistered,
            register: this.register,
            deregister: this.deregister,
          }} />
          <SearchSection manageLectures={{
            isRegistered: this.isRegistered,
            register: this.register,
            deregister: this.deregister,
          }} />
          <button onClick={this.logout}>로그아웃</button>
        </section>
      )
    }
    return (
      <main>
        <p>{System.message}</p>
        {main}
      </main>
    );
  }
});
