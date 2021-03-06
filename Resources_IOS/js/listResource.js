

var viewModel = {
    
  resources:ko.observableArray([]),
  onClick :  function(resource){
      
      var scheme = "openUrl://1?Readit=" + resource.link()
      window.open(scheme)
        
    }
    
};

var onLoad = function() {
    
    var dataFromServer
    
    loadResourceJSon = function(resJSON){
        dataFromServer = ko.utils.parseJson(JSON.stringify(resJSON))
        update()
    }
    
    update = function(){
    
        var mappedData = ko.utils.arrayMap(dataFromServer, function(resource) {
                                           return new Resource(resource.title, resource.link);
                                           });
        viewModel.resources(mappedData);
        viewModel.mappedData = mappedData
        ko.applyBindings(viewModel);
    }

    


    
};



