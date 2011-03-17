
function fn_initialize_bids() {
    $('#post_expiry').datepicker();

    $('#offering').change( function() {
            alert($(this).val() );
        });
}