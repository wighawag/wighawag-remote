package com.wighawag.remote.service;



class RetryMessage 
{

	public var retry(default, null) : Int;
	public var text(default, null) : String;
	
	public function new(text : String, retry : Int) 
	{
		this.text = text;
		this.retry = retry;
	}
	
}