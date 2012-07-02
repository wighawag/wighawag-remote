package com.wighawag.remote.local;

import com.wighawag.remote.service.Alternative;
import com.wighawag.remote.service.ErrorMessage;
import com.wighawag.remote.service.HighScoreService;
import com.wighawag.remote.service.Response;
import com.wighawag.remote.service.RetryMessage;
import com.wighawag.remote.service.Score;
import com.wighawag.remote.service.Seed;
import haxe.Timer;
import nme.Lib;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class DynamicObject implements Dynamic {
	public function new(){}
}

class LocalHighScoreService implements HighScoreService
{
	
	public function new() 
	{
		
	}
	
	public function echo(message : String) : Response<String, ErrorMessage>
	{
		var response : Response<String, ErrorMessage> = new Response<String, ErrorMessage>();
		Timer.delay(function():Void { response.processSuccess(message); }, 100);
		return response;
	}
	
	public function start() : Response<Seed, ErrorMessage>
	{
		var response : Response<Seed, ErrorMessage> = new Response<Seed, ErrorMessage>();
		Timer.delay(function():Void { 
			var seedList : Array<Int> = new Array<Int>();
			seedList.push(Math.floor(Math.random() * 2147483647));
			seedList.push(Math.floor(Math.random() * 2147483647));
			seedList.push(Math.floor(Math.random() * 2147483647));
			seedList.push(Math.floor(Math.random() * 2147483647));
			var result : Seed = new Seed(seedList, "1");
			response.processSuccess(result);
		}, 100);
		return response;
	}

	
	/*
	 * 	scoreValue = score['score']
		scoreTime = score['time']
		proof = score['proof']
	*/
	public function setScore(score : Score) : Response<String, ErrorMessage>
	{
		var response : Response<String, ErrorMessage> = new Response<String, ErrorMessage>();
		Timer.delay(function():Void { 
			response.processSuccess("success");
		}, 100);
		return response;
	}
	
	public function getOwnHighScore():Response<Score, ErrorMessage>
	{
		var response : Response<Score, ErrorMessage> = new Response<Score, ErrorMessage>();
		Timer.delay(function():Void { 
			var score : Score = new Score(0, 0, null, null, "1" );
			response.processSuccess(score);
		}, 100);
		return response;
	}
	
	public function getRandomScore():Response<Alternative<Score,RetryMessage>, ErrorMessage>
	{
		var response : Response<Alternative<Score,RetryMessage>, ErrorMessage> = new Response<Alternative<Score,RetryMessage>, ErrorMessage>();
		Timer.delay(function():Void { 
			response.processError(new ErrorMessage("2147483647"));
		}, 100);
		return response;
	}

	public function reviewScore(scoreReview : Score):Response<String, ErrorMessage> 
	{
		var response : Response<String, ErrorMessage> = new Response<String, ErrorMessage>();
		Timer.delay(function():Void { 
			response.processSuccess("7");
		}, 100);
		return response;
	}
	
	
	
	//admin
	public function forceReviewTimeUnit(value : Int) : Response<Int, ErrorMessage>
	{
		var response : Response<Int, ErrorMessage> = new Response<Int, ErrorMessage>();
		Timer.delay(function():Void { 
			response.processSuccess(0);
		}, 100);
		return response;
	}
	
}