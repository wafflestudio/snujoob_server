var message = $('#message')
var student_id = getCookie('student_id');
var token = getCookie('token')
var registered_list = []

message.html('자동 로그인 중입니다')

function auto_login(){
  if (student_id === '' || token === ''){
    message.html('로그인이 필요합니다')
    $('#login-section').show()
    return
  }
  var params = {'student_id': student_id}
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
      message.html('')
      $('#after-login').show()
      $('.student-id').html(student_id)
      get_user_info()
    } else {
      message.html('로그인이 필요합니다')
      $('#login-section').show()
    }
  })
}
auto_login()

$("#login-section button").click(function (){
  var student_id = $('input[name=student-id]').val()
  var password = $('input[name=password]').val()
  login(student_id, password);
});
function login(s, p){
  var pattern = /20[0-9]{2}-[12][0-9]{4}/;
  if (s === '' || p === '' || !pattern.test(s)){
    message.html('아이디와 비밀번호를 확인해주세요')
    return;
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
      token = data.token
      student_id = s
      message.html('')
      $('#login-section').hide()
      $('#after-login').show()
      y
      $('.student-id').html(student_id)
      setCookie('student_id', student_id, 7)
      setCookie('token', token, 7)
      get_user_info()
    } else {
      message.html('로그인에 실패했습니다')
    }
  })
}

function get_user_info(){
  $.ajax({
    beforeSend: function (xhr){
      xhr.setRequestHeader('x-user-token', token)
    },
    url: '/users/' + student_id,
    type: 'get',
    dataType: 'json'
  }).done(function (data){
    var lectures = data.lectures
    var tbody = $('#registered-lectures tbody')
    registered_list = []
    index = 0
    tbody.html('')
    lectures.forEach(function (lecture, index){
      var tr = '<tr>'
        tr += '<td style="display: none;">'+ lecture.id +'</td>'
          registered_list[index++] = lecture.id
        tr += '<td>'+ lecture.subject_number + ' ' + lecture.lecture_number +'</td>'
        tr += '<td>'+ lecture.name +'</td>'
        tr += '<td>'+ lecture.lecturer +'</td>'
        tr += '<td>'+ lecture.time +'</td>'
        tr += '<td>'+ lecture.enrolled + ' / ' + lecture.whole_capacity +'</td>'
        tr += '<td>'+ lecture.competitors_number +'</td>'
        tr += '<td>'+ '<button class="unregister">해제</button>' +'</td>'
      tr += '</tr>'
      tbody.append(tr)
    })
    binding_on_registered_lectures()
  })
}

function binding_on_registered_lectures(){
  $('#registered-lectures tbody .unregister').click(function (){
    var lecture_id = $(this).parent().parent().children()[0].innerHTML
    unregister(lecture_id)
  })
}

function unregister(lecture_id){
  params = {'lecture_id': lecture_id}
  $.ajax({
    beforeSend: function (xhr){
      xhr.setRequestHeader('x-user-token', token)
    },
    url: '/users/' + student_id + '/unregister',
    type: 'post',
    contentType: 'application/json',
    data: JSON.stringify(params),
    dataType: 'json',
  }).done(function (data){
      message.html('강의를 해제했습니다')
      get_user_info()
    if (data.result){
    } else {
      message.html('실패')
    }
  })
}

function register(lecture_id){
  params = {'lecture_id': lecture_id}
  $.ajax({
    beforeSend: function (xhr){
      xhr.setRequestHeader('x-user-token', token)
    },
    url: '/users/' + student_id + '/register',
    type: 'post',
    contentType: 'application/json',
    data: JSON.stringify(params),
    dataType: 'json',
  }).done(function (data){
      message.html('강의를 등록했습니다')
      get_user_info()
    if (data.result){
    } else {
      message.html('실패')
    }
  })
}

$('#search-section button').click(function (){
  search()
})

function search(){
  message.html('')
  var q = $('input[name=query]').val()
  if (q === ""){
    message.html('검색어를 입력해주세요')
    return;
  }
  $.ajax({
    url: '/search?query=' + q,
    dataType: 'json',
  }).done(function (data){
    var lectures = data.lectures
    var tbody = $('#searched-lectures tbody')
    tbody.html('')
    lectures.forEach(function (lecture, index){
      var tr = '<tr>'
        tr += '<td style="display: none;">'+ lecture.id +'</td>'
        tr += '<td>'+ lecture.subject_number + ' ' + lecture.lecture_number +'</td>'
        tr += '<td>'+ lecture.name +'</td>'
        tr += '<td>'+ lecture.lecturer +'</td>'
        tr += '<td>'+ lecture.time +'</td>'
        tr += '<td>'+ lecture.enrolled + ' / ' + lecture.whole_capacity +'</td>'
        tr += '<td>'+ lecture.competitors_number +'</td>'
        tr += '<td>'
        if ($.inArray(lecture.id, registered_list) !== -1){
          // 등록되었으면
          tr += '<div class="reg">'
        } else {
          tr += '<div class="unreg">'
        }
          tr += '<button class="register">등록</button>'
          tr += '<button class="unregister">해제</button>'
          tr += '</div>'
        tr += '</td>'
        tr += '</tr>'
      tbody.append(tr)
    })
    binding_on_searched_lectures()
  })
}

function binding_on_searched_lectures(){
  $('#searched-lectures tbody .unregister').click(function (){
    var lecture_id = $(this).parent().parent().parent().children()[0].innerHTML
    $(this).parent().children().toggle()
    unregister(lecture_id)
  })
  $('#searched-lectures tbody .register').click(function (){
    var lecture_id = $(this).parent().parent().parent().children()[0].innerHTML
    $(this).parent().children().toggle()
    register(lecture_id)
  })
}

$('#logout').click(function (){
  setCookie('student_id', '', 0)
  setCookie('token', '', 0)
  message.html('로그아웃하셨습니다')
  token = ''
  student_id = ''
  $('#login-section').show()
  $('#after-login').hide()
})

function setCookie(cname, cvalue, exdays) {
  var d = new Date();
  d.setTime(d.getTime() + (exdays*24*60*60*1000));
  var expires = "expires="+d.toUTCString();
  document.cookie = cname + "=" + cvalue + "; " + expires;
}
function getCookie(cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0)==' ') c = c.substring(1);
      if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
  }
  return "";
}
