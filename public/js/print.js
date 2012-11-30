var nextAvail

function check_input(url, value) {
    $.getJSON( url+value, function(result){
        console.log(result)
        if ( result["check"] ) {
            $('.inputs').addClass('success')
            $('#nextAvail').attr('disabled', 'disabled')
        } else {
            $('.inputs').addClass('error')
            nextAvail = result['next']
            $('#nextAvail').removeAttr('disabled')
        }
        $('.check-message').html(result["message"])
    })
}

$(document).ready(function(){

    $('#printValue').submit(function(){
        $.post('/add/value/'+$('#inputPCOID').val(), function(){
            location.reload();
        })
        // Prevent default behavior from happening
        return false
    })

    $('#nextAvail').on('click', function( e ){
        if ( $('#inputPCOID').val() ) {
            $('#inputPCOID').val(nextAvail)
            check_input('/check/value/', nextAvail)
        }
    });

    $('#submitRange').on('click', function( e ){
        $('#printValue').submit()
    });

    $('#inputPCOID').on('keyup', function(){
        $('.inputs').attr('class', 'control-group inputs')
        $('.check-message').html('')
        if ( $('#inputPCOID').val() ) {
            check_input('/check/value/', $('#inputPCOID').val())
        }
    })

});
