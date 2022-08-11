$(document).on('turbolinks:load', function() {
  var files = [];
  $('#fileupload').fileupload({
    dataType: 'json',
    url: '/documents/chunk_create',
    maxChunkSize: 1000000,
    add: function(e, data) {
      $.each(data.files, function(index, file) {
        $.ajax({
          method: 'post',
          dataType: 'json',
          url: '/documents',
          data: { original_filename: file.name },
          success: function(res) {
            data.formData = res;
            files.push(data);
          }
        });
      });
    },
    done: function(e, data){
      $.ajax({
        method: 'get',
        dataType: 'json',
        url: ('/documents/compress?id=' + data.result.id + '&title=' + $('#title').val() + '&description=' + $('#description').val()),
        success: function(res) {
          window.location.href = "/documents/" + data.result.id + '?flash_msg=Document Successfully Uploaded.'
        }
      });
    },
    progressall: function(e, data) {
      var done = parseInt(data.loaded * 100) / data.total
      $('#progress').css({ width: done + '%'})
    }
  });

  $('#fileupload').on('submit', function(e) {
    e.preventDefault();
    if (files.length < 1) return;

    $.each(files, function(index, file) {
      file.submit();
    });

    files = [];
  });
})
