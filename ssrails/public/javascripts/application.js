


function fnMainMenu() {

}



function fnOnLoginStatusChanged( action_name ) {
    var action = null;

    if( action_name == 'login' && window.location.pathname == '/account/not_signed_in' ) {
        action = window.location.protocol + '//' + window.location.host +  '/account/login?redirect=' +
            window.location.protocol + '//' + window.location.host + '/';
    } else {
        action = window.location.protocol + '//' + window.location.host + '/account/' +
            action_name + '?redirect=' + window.location.href;
    }

    window.location.href = action;
}

function fnOnFBSessionStatus(session) {

    
    // set up event handlers for login/logout links
    // note that visibility of these links is 
    // controlled by event handlers defined elsewhere
    $('a#logout').click( function(e) {
            e.preventDefault();
            FB.logout( null );
        });
    $('a#login').click(function(e){
            e.preventDefault();
            FB.login( null ); 
        });
    
}

function fnFacebookInit() {
    window.fbAsyncInit = function() {
        FB.init( { appId : '129272647132490', status : true, cookie : true, xfbml : true } );
        
        FB.getLoginStatus(function(response) {
            if( response.session ) {
                fnOnFBSessionStatus(response.session);
            } else {
                fnOnFBSessionStatus();
            }
        });
        

        FB.Event.subscribe( 'auth.logout', function( response ) {
                fnOnLoginStatusChanged( 'logout' );
            });
        FB.Event.subscribe( 'auth.login', function( response ) {
                fnOnLoginStatusChanged( 'login' );
            });


    };

    (function() {
        var e = document.createElement('script'); e.async = true;
    e.src = document.location.protocol +
        '//connect.facebook.net/en_US/all.js';
    document.getElementById('fb-root').appendChild(e);
    }());


}