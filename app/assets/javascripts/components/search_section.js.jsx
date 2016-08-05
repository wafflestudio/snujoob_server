var SearchSection = React.createClass({
  /* - props
   *
   * - state
   * lectures
   */
  getInitialState: function(){
    return {
      searchedLectures: [],
    }
  },
  searchMethod: function(q){
    $.ajax({
      url: '/search?query=' + q,
      dataType: 'json',
    }).done(function (data){
      var lectures = data.lectures
      this.setState({searchedLectures: lectures})
    }.bind(this))
  },
  render: function(){
    return (
      <section>
        <h2>검색</h2>
        <SearchForm searchMethod={this.searchMethod} />
        <LectureList lectures={this.state.searchedLectures} manageLectures={this.props.manageLectures} />
      </section>
    );
  }
});

var SearchForm = React.createClass({
  /* - props
   * searchMethod
   * 
   * - refs
   * query
   */
  render: function(){
    return (
      <div>
        <input ref="query" placeholder="컴개실 (과목명만 가능합니다)" />
        <button onClick={() => this.props.searchMethod(this.refs.query.value)}>검색</button>
      </div>
    );
  }
});
