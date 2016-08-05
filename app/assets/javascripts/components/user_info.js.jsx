var UserInforSection = React.createClass({
  /* - props
   * lectures
   */
  render: function(){
    return (
      <section>
        <h2>등록한 과목</h2>
        <LectureList lectures={this.props.lectures} registeredLectures={this.props.lectures} manageLectures={this.props.manageLectures} />
      </section>
    );
  }
});
