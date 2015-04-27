
```
class InfoEntry{key:String, value:Object}
```

### Parameters ###

`key` - the key name of the `InfoEntry`, such as `logo_swf_full_url`.

`value` - the value of the `InfoEntry`,such as the full URL of the logo in the case of `logo_swf_full_url`.

### Creation ###

To create a `InfoEntry` instance you must use it's create function and not a constructor:

```
InfoEntry.create(key,value);
```