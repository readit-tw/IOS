var items = function()
{
	return [];//{"baseUrl":"http://www.infoq.com/favicon.ico","id":"55db2b1cd50ad22a42000001","title":"Eclipse BUndle recipes","link":"http://www.infoq.com/presentations/eclipse-bundle-recipes?utm_source=infoq\u0026utm_medium=videos_homepage\u0026utm_campaign=videos_row1","type":"text/html;charset=utf-8"},{"id":"55dbe739d50ad2449b000001","title":"Stack Share","link":"http://stackshare.io/","type":"text/html; charset=utf-8"}];
}

var Item = function(title) {
	return {title: title};
}

var AppViewModel = function() {
	var self = this;
	self.items = ko.observableArray(items());

	self.pushItems = function(list) {
		self.items.removeAll();
		 for(var i = 0; i < list.length; i++) {
			 var listItem = list[i];
			 // TODO - Identify a situation where cant find favicon and set default image ?
			 listItem.baseUrl = extractDomain(listItem.link);
			 self.items.push(listItem);

		 }
 	}

    self.itemClick = function (item) {
     	ListView.onItemClick(item.link);
    };

}

function extractDomain(url) {
	//  create an anchor element (note: no need to append this element to the document)
	var link = document.createElement('a');

	//  set href to any path
	link.setAttribute('href', url);

	//  get any piece of the url you're interested in
	//link.hostname;  //  'example.com'
	//link.port;      //  12345
	//link.search;    //  '?startIndex=1&pageSize=10'
	//link.pathname;  //  '/blog/foo/bar'
	//link.protocol;  //  'http:'
	alert(link.protocol);
    return link.protocol+ "//" + link.hostname + "/favicon.ico";
}

var appViewModel = new AppViewModel();

var renderList = function() {
	ko.applyBindings(appViewModel);
}

var onListLoad = function(list) {
    alert(list)
	appViewModel.pushItems(list);
}