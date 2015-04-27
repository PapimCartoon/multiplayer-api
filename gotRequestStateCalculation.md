
```
gotRequestStateCalculation(requestId:int,serverEntries:Array/*ServerEntry*/)
```

### Description ###

This callback is triggered by a [doAllRequestStateCalculation](doAllRequestStateCalculation.md) call, after getting this callback
the flash should recognize it is a calculator and do the appropriate calculations

To save the calculations made by the calculator you should call [doAllStoreStateCalculation](doAllStoreStateCalculation.md)

### Parameters received ###

serverEntries - an Array of [ServerEntry](ServerEntry.md) elements, containing the server entries specified in the
[doAllRequestStateCalculation](doAllRequestStateCalculation.md) call.

requestId - a unique id specified by the server ,this id should not be used in any calculations and should be returned as is in a [doAllStoreStateCalculation](doAllStoreStateCalculation.md) call.

To save server entries using this callback function you should call [doAllStoreStateCalculation](doAllStoreStateCalculation.md).

### Example ###

lets suppose this is a mine sweeper calculator.
we expect a random number stored by the server via a [doAllRequestRandomState](doAllRequestRandomState.md)

```
override public function gotRequestStateCalculation(serverEntries:Array):void
{
	/*
	check if the serverEntries received from  the users are legal
	do whatever calculations needed 
	and then store them using 
	*/
	if (serverEntry.storedByUserId != -1) doAllFoundHacker(serverEntry.storedByUserId,"If the storedByUserId is different from -1,then this was not saved by the server and player which saved it there probably broke protocol");
	doAllStoreStateCalculation(createdUserEntries);
}

```