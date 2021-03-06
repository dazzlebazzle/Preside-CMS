---
id: "form-formbuilderitemtypeallformfields"
title: "Form builder item type: All form fields"
---

This form is used as a core configuration for Form Builder item types that
are defined as form fields. If the item type provides its own configuration,
it will be merged with this form definition.

<div class="table-responsive"><table class="table table-condensed"><tr><th>File path</th><td>/forms/formbuilder/item-types/formfield.xml</td></tr><tr><th>Form ID</th><td>formbuilder.item-types.formfield</td></tr></table></div>

```xml
<?xml version="1.0" encoding="UTF-8"?>

<form i18nBaseUri="formbuilder.item-types.formfield:">
    <tab id="default" sortorder="10">
        <fieldset id="default" sortorder="10">
            <field name="label" control="textinput" required="true" sortorder="10" />
            <field name="name"  control="textinput" required="true" sortorder="20">
                <rule validator="match" message="formbuilder.item-types.formfield:validation.error.invalid.name.format">
                    <param name="regex" value="^[a-zA-Z][a-zA-Z0-9_]*$" />
                </rule>
            </field>
            <field name="layout"    control="formbuilderFieldLayoutPicker" required="true"  sortorder="30" />
            <field name="mandatory" control="yesnoswitch"                  required="false" sortorder="40" />
            <field name="help"      control="textarea"                     required="false" sortorder="50" />
        </fieldset>
    </tab>
</form>
```