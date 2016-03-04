---
id: "formbuildervalidationservice-getitemtypespecificrulesforformfield"
title: "getItemTypeSpecificRulesForFormField()"
---


## Overview




```luceescript
public array function getItemTypeSpecificRulesForFormField(
      required string itemType     
    , required struct configuration
)
```

Returns an array of validation rules generated by a custom rule generator for the given
item type, if present.

## Arguments


<div class="table-responsive"><table class="table"><thead><tr><th>Name</th><th>Type</th><th>Required</th><th>Description</th></tr></thead><tbody><tr><td>itemType</td><td>string</td><td>Yes</td><td>The type of item who's rules you wish to generate</td></tr><tr><td>configuration</td><td>struct</td><td>Yes</td><td>The saved configuration for the item who's rules you wish to generate</td></tr></tbody></table></div>