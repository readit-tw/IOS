/**
 * Create a tags Bloodhound
 *
 * @type {Bloodhound}
 */
var tags = new Bloodhound({
    datumTokenizer : Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer : Bloodhound.tokenizers.whitespace,
    remote: {
         url: 'http://readit.thoughtworks.com/tags/%QUERY',
        wildcard: '%QUERY'
    }
});
tags.initialize();

var elt = $('input.typehead-input');
elt.materialtags({
    freeInput:true,
    typeaheadjs : {
        name       : 'tags',
        displayKey : 'name',
        valueKey   : 'name',
        source     : tags.ttAdapter()
    }
});
