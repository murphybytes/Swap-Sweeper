
function fn_initialize_bids() {
    $('#post_expiry').datepicker();

    $('#offering').change( function() {

            if( $(this).val() ) {
                $('#bid-offering-area').show();
                $( '.' + $(this).val() ).show();
            }
        });
    $('.bid-offering-rcol a').button({icons: { primary: 'ui-icon-close' } }   );
    $( '#new-bid-submit' ).button( {icons: { primary: 'ui-icon-check' }} );
    $( '#new-bid-cancel' ).button( {icons: {primary: 'ui-icon-close' }} );

    $('.remove-button').click( function(e) {
            e.preventDefault();
            $(this).parent().parent().hide();
            var item_row_visible = false;
            $('.bid-offering-row').each( function() {
                    var value = $(this).css('display');
                    
                    if( value != 'none' ) {
                        item_row_visible = true;
                    }
                });
            if( !item_row_visible ) {
                $('#bid-offering-area').hide();
            }
        });

    $('#new-bid-submit').click( function(e) {
            e.preventDefault();
            var count = 0;
            $( '.bid-offering-row').each( function() {
                    var display_attr_value = $(this).css('display');
                    if( display_attr_value != 'none' ) {
                        $('form').append( "<input type='hidden' name='offerings[" + count + "]' value=" + $(this).attr('class') + " />" );
                        count += 1;
                    }
                });
            $('form').submit();
        });
}