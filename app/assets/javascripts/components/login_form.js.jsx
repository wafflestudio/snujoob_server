var LoginSection = React.createClass({
  /* - props
   * login
   */
  login: function(){
    this.props.login(this.refs.studentId.value, this.refs.password.value)
  },
  render: function(){
    return (
      <section>
        <div>
          <input ref="studentId" placeholder="2015-xxxxx" />
        </div>
        <div>
          <input ref="password" placeholder="password" type="password" />
        </div>
        <div>
          <button onClick={this.login}>login</button>
        </div>
      </section>
    );
  }
});
