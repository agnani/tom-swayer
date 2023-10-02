package com.companyname.function;


import com.tomsawyer.util.evaluator.shared.TSEvaluationException;
import com.tomsawyer.util.evaluator.shared.TSEvaluator;
import com.tomsawyer.util.evaluator.shared.TSEvaluatorData;
import com.tomsawyer.util.logging.TSLogger;
import org.springframework.stereotype.Component;


/**
 * Custom function.
 */
@Component
@TSEvaluator.Specification(group = "Custom Functions",
name = "placeholderCustomFunction",
description = "This is a custom function",
parameters = {"file"},
parametersDescription = {"A file with location relative to the working directory."})
public class PlaceholderCustomFunction implements TSEvaluator
{
	@Override
	public Object evaluate(TSEvaluatorData data) throws TSEvaluationException
	{
		Object[] arguments = data.getArguments();

		if (arguments.length == 0)
		{
			throw new TSEvaluationException("Missing function parameter!");
		}

		TSLogger.info(this.getClass(),
			"Placeholder custom function called with parameter: {0}",
			arguments[0]);

		return arguments[0];
	}


	/**
	 * This method indicates whether the argument of a function is evaluated
	 * before it is passed to the evaluator.
	 */
	@Override
	public boolean isEvaluateArgument(String name, int index)
	{
		return false;
	}
}
