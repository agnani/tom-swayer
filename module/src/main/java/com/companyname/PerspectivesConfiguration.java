package com.companyname;


import com.companyname.action.PlaceholderDrawingViewAction;
import com.companyname.command.PlaceholderCommand;
import com.companyname.function.PlaceholderCustomFunction;
import com.tomsawyer.util.evaluator.shared.TSEvaluator;
import com.tomsawyer.view.behavior.TSActionItemDefinition;
import com.tomsawyer.web.server.command.TSServiceCommandImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;


/**
 * This configuration class is used to instantiate beans.
 */
@Configuration
class PerspectivesConfiguration
{
	@Bean
	public TSActionItemDefinition getPlaceholderAction()
	{
		return new PlaceholderDrawingViewAction();
	}

	@Bean
	public TSServiceCommandImpl getPlaceholderCommand()
	{
		return new PlaceholderCommand();
	}

	@Bean
	public TSEvaluator getPlaceholderCustomFunction()
	{
		return new PlaceholderCustomFunction();
	}
}
