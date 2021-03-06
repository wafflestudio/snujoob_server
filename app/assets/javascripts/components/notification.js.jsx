var Notification = React.createClass({
  push: function(id){
    if (this.props.isRegistered(id)){
      var lecture = this.props.getRegistered(id)
      var link = <a href="http://sugang.snu.ac.kr/sugang/co/co012.action">수강신청 페이지로 가기</a>
      var sound = <audio loop autoPlay><source src="http://leeingnyo.me:8080/repository/44f0f77e92596c0707bea55d1a079793cac50a28faa2b951c5adca0e37b0cb3e/%EA%B8%B0%EC%83%81%EB%82%98%ED%8C%94.mp3" type="audio/mpeg" /></audio>
      var info = '[' + lecture.subject_number + ' ' + lecture.lecture_number + '] '
          + lecture.name +  '(' + lecture.lecturer + ') 자리가 비었습니다!'
      var a = setInterval(function(){
        alert(info)
        clearInterval(a)
      }, 1 * 1000)
      this.setState({message: <span> <span>{info + '노래는 못 꺼요... 새로고침 해주세요...'}</span> {link} {sound} </span>})
    }
  },
  getInitialState: function(){
    return {
      pushed: false,
      message: null,
    };
  },
  componentDidMount: function(){
    this.props.chan.bind('push', function(data){
      this.push(data.lecture_id)
    }.bind(this))
  },
  render: function(){
    return (
      <p>{this.state.message}</p>
    );
  }
});
