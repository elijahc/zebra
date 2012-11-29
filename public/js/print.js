function api_check(url, params, something) {

}

$(document).ready(function(){

    $('#printRange').submit(function(){
        $.post('/add/value/'+$('#inputPCOID').val(), function(){
            location.reload();
        })
        // Prevent default behavior from happening
        return false
    })

    $('#submitRange').on('click', function( e ){
        $('#printRange').submit()
    });

    $('#inputPCOID').on('keyup', function(){
        $('.inputs').attr('class', 'control-group inputs')
        $('.check-message').html('')
        if ( $('#inputPCOID').val() ) {
            $.getJSON( '/check/value/'+$('#inputPCOID').val(), function(result){
                console.log(result)
                if ( result["check"] ) {
                    $('.inputs').addClass('success')
                } else {
                    $('.inputs').addClass('error')
                }
                $('.check-message').html(result["message"])
            })
        }
    })

});
