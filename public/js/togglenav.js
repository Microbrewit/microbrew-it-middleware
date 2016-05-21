var navigation = document.getElementById('main-navigation'),
	moreButton = document.getElementById('more'),
	body = (document.getElementsByTagName('body'))[0];

var hideNav = function (e) {
	navigation.className = '';
	moreButton.className = moreButton.className.replace('active', '').trim();
}

var showNav = function (e) {
	navigation.className = 'display';
	moreButton.className += ' active';
}

var toggleNav = function (e) {

	e.stopPropagation();

	if(navigation.className.indexOf('display') !== -1) {
		hideNav();
	}
	else {
		showNav();
	}
}

hideNav()

body.onclick = hideNav;
more.onclick = toggleNav;