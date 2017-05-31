import $ from "jquery";
import socket from './socket';

function start() {
  $('#action-button').text('Stop');
  $('#action-button').removeClass('btn-primary').addClass('btn-danger');
  let requestsPerMinute = parseInt($('#requests').val(), 10);
  let url = $('#url').val();
  $.ajax({
    url: '/start',
    method: 'post',
    data: {
      requests: requestsPerMinute,
      url: url
    }
  });
}

function stop() {
  $('#action-button').text('Start');
  $('#action-button').removeClass('btn-danger').addClass('btn-primary');
  $.ajax({
    url: '/stop',
    method: 'post'
  });
}

$(document).ready(function() {
  let running = false;
  $('#action-button').click(function(e){
    e.preventDefault();
    if(running) {
      stop();
      running = false;
    } else {
      start();
      running = true;
    }
  });
  let dataChannel = socket.channels[0];
  dataChannel.on('report', (result) => {
    $('#responses').append(`<div class="row"><div class="col-xs-12">${JSON.stringify(result)}</div></div>`);
    $('#responses').scrollTop($('#responses')[0].scrollHeight);
  });
});
