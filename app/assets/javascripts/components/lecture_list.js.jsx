var LectureList = React.createClass({
  /* - props
   * lectures
   * manageLectures
   */
  render: function(){
    var LectureItems = this.props.lectures.map(function(lecture){
      return (
        <LectureItem lecture={lecture} isRegistered={this.props.manageLectures.isRegistered(lecture.id)} onClick={
          (this.props.manageLectures.isRegistered(lecture.id)
            ? this.props.manageLectures.deregister
            : this.props.manageLectures.register)
        } key={lecture.id} />
      );
    }.bind(this))
    return (
      <table>
        <thead>
          <tr>
            <th></th>
            <th>번호</th>
            <th>제목</th>
            <th>교수</th>
            <th>시간</th>
            <th>정보</th>
            <th>경쟁자수</th>
            <th>관리</th>
          </tr>
        </thead>
        <tbody>
          {LectureItems}
        </tbody>
      </table>
    );
  }
});

var LectureItem = React.createClass({
  /* - props
   * lecture
   * is_registered
   */
  register: function(){
    // fixme
    console.log(this.props.lecture.id + ' 등록');
  },
  deregister: function(){
    // fixme
    console.log(this.props.lecture.id + ' 해제');
  },
  render: function(){
    var button;
    if (!this.props.isRegistered){
      button = <button onClick={() => {this.props.onClick(this.props.lecture.id)}}>등록</button>
    }
    else {
      button = <button onClick={() => {this.props.onClick(this.props.lecture.id)}}>해제</button>
    }
    return (
      <tr>
        <td>{this.props.lecture.id}</td>
        <td>{this.props.lecture.subject_number} {this.props.lecture.lecture_number}</td>
        <td>{this.props.lecture.name}</td>
        <td>{this.props.lecture.lecturer}</td>
        <td>{this.props.lecture.time}</td>
        <td>{this.props.lecture.enrolled} / {this.props.lecture.whole_capacity}</td>
        <td>{this.props.lecture.competitors_number}</td>
        <td>{button}</td>
      </tr>
    );
  }
});
