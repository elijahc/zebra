$(document).ready(function(){
    $('#submitRange').on('click', function(){
        $.post('/range/'+$('#inputStartValue').val()+'/to/'+$('#inputEndValue').val())
    });
});
