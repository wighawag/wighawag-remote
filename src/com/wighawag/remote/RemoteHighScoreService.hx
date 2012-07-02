package com.wighawag.remote;

import com.wighawag.remote.service.Alternative;
import com.wighawag.remote.service.ErrorMessage;
import com.wighawag.remote.service.HighScoreService;
import com.wighawag.remote.service.Response;
import com.wighawag.remote.service.RetryMessage;
import com.wighawag.remote.service.Score;
import com.wighawag.remote.service.Seed;
import nme.Lib;

import hsl.haxe.DirectSignaler;
import hsl.haxe.Signaler;

class RemoteHighScoreService implements HighScoreService
{
	private var remote : RemoteCall;
	
	public function new(remote : RemoteCall)
	{
		this.remote = remote;
	}
	
	public function echo(message : String) : Response<String, ErrorMessage>
	{
		var response : Response<String, ErrorMessage> = new Response<String, ErrorMessage>();
		remote.signedRequestCall(["score.service.echo", [message]]).bind(function(value : Dynamic): Void {
			if (Reflect.hasField(value, "result"))
			{
				response.processSuccess(value.result);
			}
			else
			{
				response.processError(new ErrorMessage(value.error.message)); // TODO : if transaction error should retry imeditaly without letting the respons ebe processed yet (TO be applied to all the service api
			}
		});
		return response;
	}
	
	public function start() : Response<Seed, ErrorMessage>
	{
		var response : Response<Seed, ErrorMessage> = new Response<Seed, ErrorMessage>();
		remote.signedRequestCall(["score.service.start"]).bind(function(value : Dynamic): Void {
			if (Reflect.hasField(value, "result"))
			{
				response.processSuccess(new Seed(value.result.seed, "1")); // TODO use version from server
			}
			else
			{
				response.processError(new ErrorMessage(value.error.message)); // TODO : if transaction error should retry imeditaly without letting the respons ebe processed yet (TO be applied to all the service api
			}
		});
		return response;
	}
	
	/*
	 * 	scoreValue = score['score']
		scoreTime = score['time']
		proof = score['proof']
	*/
	public function setScore(score : Score) : Response<String, ErrorMessage>
	{
		var scoreValues : Hash<Dynamic> = new Hash<Dynamic>();
		scoreValues.set("score", score.value);
		scoreValues.set("time", score.time);
		scoreValues.set("proof", score.proof);
		var response : Response<String, ErrorMessage> = new Response<String, ErrorMessage>();
		remote.signedRequestCall(["score.service.setScore", [scoreValues]]).bind(function(value : Dynamic): Void {
			if (Reflect.hasField(value, "result"))
			{
				response.processSuccess(value.result.message);
			}
			else
			{
				response.processError(new ErrorMessage(value.error.message)); // TODO : if transaction error should retry imeditaly without letting the respons ebe processed yet (TO be applied to all the service api
			}
		});
		return response;
	}
	
	public function getOwnHighScore():Response<Score, ErrorMessage>  
	{
		var response : Response<Score, ErrorMessage> = new Response<Score, ErrorMessage>();
		remote.signedRequestCall(["score.service.getOwnHighScore"]).bind(function(value : Dynamic): Void {
			if (Reflect.hasField(value, "result"))
			{
				response.processSuccess(new Score(value.result.score,value.result.time, null, null, "1")); // TODO use version given by server
			}
			else
			{
				response.processError(new ErrorMessage(value.error.message)); // TODO : if transaction error should retry imeditaly without letting the respons ebe processed yet (TO be applied to all the service api
			}
		});
		return response;
	}
	
	public function getRandomScore():Response<Alternative<Score,RetryMessage>, ErrorMessage>
	{
		var response : Response<Alternative<Score,RetryMessage>, ErrorMessage> = new Response<Alternative<Score,RetryMessage>, ErrorMessage>();
		remote.signedRequestCall(["score.service.getRandomScore"]).bind(function(value : Dynamic): Void {
			if (Reflect.hasField(value, "result"))
			{
				var alternative : Alternative<Score,RetryMessage>;
				if (Reflect.hasField(value.result, "retry"))
				{
					alternative = new Alternative<Score,RetryMessage>(null, new RetryMessage(value.result.message, value.result.retry));
				}
				else
				{
					alternative = new Alternative<Score,RetryMessage>(new Score(-1, -1, value.result.proof, value.result.seed, value.result.version));
				}
				response.processSuccess(alternative);
			}
			else
			{
				response.processError(new ErrorMessage(value.error.message)); // TODO : if transaction error should retry imeditaly without letting the respons ebe processed yet (TO be applied to all the service api
			}
		});
		return response;
	}
	
	public function reviewScore(scoreReview : Score):Response<String, ErrorMessage>
	{
		var scoreValues : Hash<Dynamic> = new Hash<Dynamic>();
		scoreValues.set("score", scoreReview.value);
		scoreValues.set("time", scoreReview.time);
		var response : Response<String, ErrorMessage> = new Response<String, ErrorMessage>();
		remote.signedRequestCall(["score.service.reviewScore", [scoreValues]]).bind(function(value : Dynamic): Void {
			if (Reflect.hasField(value, "result"))
			{
				response.processSuccess(value.result.message);
			}
			else
			{
				response.processError(new ErrorMessage(value.error.message)); // TODO : if transaction error should retry imeditaly without letting the respons ebe processed yet (TO be applied to all the service api
			}
		});
		return response;
	}
	
	
	
	//admin
	public function forceReviewTimeUnit(value : Int) : Response<Int, ErrorMessage>
	{
		var response : Response<Int, ErrorMessage> = new Response<Int, ErrorMessage>();
		remote.signedRequestCall(["score.service.forceReviewTimeUnit", [value]]).bind(function(value : Dynamic): Void {
			if (Reflect.hasField(value, "result"))
			{
				response.processSuccess(value.result.oldReviewTimeUnit);
			}
			else
			{
				response.processError(new ErrorMessage(value.error.message)); // TODO : if transaction error should retry imeditaly without letting the respons ebe processed yet (TO be applied to all the service api
			}
		});
		return response;
	}
	
}