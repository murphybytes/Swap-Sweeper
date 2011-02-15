function MenuItem( elt ) {
    this.elt = elt;
    var parts = elt.id.split("_");
    this.index = parseInt( parts[1]);
    this.menu_target = elt.protocol + "//" + elt.host + "/account/" + parts[0];

}

MenuItem.prototype.invoke = function() {
  if( $(this.elt).hasClass('unselected') ) {
      location = this.menu_target;
  }
}

$(document).ready( function() {

    var page_menu_id = $('input#page_menu_id').val();


    $("a#" + page_menu_id + "_0").show();
    var selected_menu = page_menu_id + "_1";
    $('.menu-item.unselected').each( function() {
        if( this.id != selected_menu ) {
            $(this).show();
        }
    });
    $('.menu-item').click( function(e) {
        e.preventDefault();

        var menu = new MenuItem( this );
        menu.invoke();
    }) ;
});