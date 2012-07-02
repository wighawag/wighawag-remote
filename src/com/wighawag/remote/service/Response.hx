package com.wighawag.remote.service;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;
import com.wighawag.report.Report;

class Response<SuccessType, ErrorType : ServiceError>
{
	
	private var successSignaler : Signaler<SuccessType>;
	private var errorSignaler : Signaler<ErrorType>;
	private var errorListenedTo : Bool;
	private var successListenedTo : Bool;
	
	
	public function new() 
	{
		successSignaler = new DirectSignaler<SuccessType>(this);
		errorSignaler = new DirectSignaler<ErrorType>(this);
	}
	
	public function onSuccess(f : SuccessType -> Void) : Response<SuccessType, ErrorType>
	{
		successListenedTo = true;
		successSignaler.bind(f);
		return this;
	}
	
	public function onError(f : ErrorType -> Void) : Response<SuccessType, ErrorType>
	{
		errorListenedTo = true;
		errorSignaler.bind(f);
		return this;
	}
	
	
	// internal ?
	public function processError(error : ErrorType) : Void
	{
		if (!errorListenedTo)
		{
			Report.anError(error.text);
		}
		errorSignaler.dispatch(error);
	}
	
	public function processSuccess(success : SuccessType) : Void
	{
		successSignaler.dispatch(success);
	}
	
}