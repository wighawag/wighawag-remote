/****
* Wighawag License:
* - free to use for commercial and non commercial application
* - provided the modification done to it are given back to the community
* - use at your own risk
* 
****/

package wighawag.remote.service;

import wighawag.remote.Channels;

import msignal.Signal;

class Response<SuccessType, ErrorType : ServiceError>
{
	
	private var successSignal : Signal1<SuccessType>;
	private var errorSignal : Signal1<ErrorType>;
	private var errorListenedTo : Bool;
	private var successListenedTo : Bool;
	
	
	public function new() 
	{
		successSignal = new Signal1();
		errorSignal = new Signal1();
	}
	
	public function onSuccess(f : SuccessType -> Void) : Response<SuccessType, ErrorType>
	{
		successListenedTo = true;
		successSignal.add(f);
		return this;
	}
	
	public function onError(f : ErrorType -> Void) : Response<SuccessType, ErrorType>
	{
		errorListenedTo = true;
		errorSignal.add(f);
		return this;
	}
	
	
	// internal ?
	public function processError(error : ErrorType) : Void
	{
		if (!errorListenedTo)
		{
			Report.anError(Channels.REMOTE, error.text);
		}
		errorSignal.dispatch(error);
	}
	
	public function processSuccess(success : SuccessType) : Void
	{
		successSignal.dispatch(success);
	}
	
}