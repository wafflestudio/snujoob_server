var Notification = React.createClass({
  push: function(id){
    if (this.props.isRegistered(id)){
      var link = '<a href="http://sugang.snu.ac.kr/sugang/co/co012.action">수강신청 페이지로 가기</a>'
      var sound = '<audio loop autoplay><source src="http://leeingnyo.me/repository/44f0f77e92596c0707bea55d1a079793cac50a28faa2b951c5adca0e37b0cb3e/wu.mp3" type="audio/mpeg"></audio>'
      var a = setInterval(function(){alert('자리가 비었습니다!'); clearInterval(a)}, 1 * 1000)
      this.setState({message: '자리가 비었습니다! ' + link + sound})
    }
  },
  getInitialState: function(){
    return {
      pushed: false,
      message: '',
    };
  },
  componentDidMount: function(){
    console.log('bind')
    this.props.chan.bind('push', function(data){
      console.log('asdf')
      this.push(data.lecture_id)
      alert('asdf')
    }.bind(this))
  },
  render: function(){
    return (
      <p>{this.state.message}</p>
    );
  }
});
