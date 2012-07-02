package com.wighawag.remote.service;

class ErrorMessage implements ServiceError
{
	public var text(default, null) : String;
	
	public function new(text : String) 
	{
		this.text = text;
	}
	
}