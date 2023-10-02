package com.companyname.action;

import com.tomsawyer.util.logging.TSLogger;
import com.tomsawyer.view.TSModelView;
import com.tomsawyer.view.action.TSDrawingViewActionItemDefinition;
import com.tomsawyer.view.behavior.TSAbstractItemDefinition;
import com.tomsawyer.view.behavior.TSWebActionItem;
import com.tomsawyer.view.behavior.TSWebActionItemImplementer;
import com.tomsawyer.view.behavior.TSWebClientSideActionItemImplementer;
import com.tomsawyer.web.server.action.TSWebDrawingViewActionItem;
import java.io.Serializable;


/**
 * Custom action.
 */
@TSDrawingViewActionItemDefinition.Specification(
	folder = "Custom Actions",
	name = "Placeholder View Action",
	priority = 2)
public class PlaceholderDrawingViewAction extends TSDrawingViewActionItemDefinition
	implements TSWebActionItemImplementer, TSWebClientSideActionItemImplementer
{
	@Override
	public TSWebActionItem newWebImplementation()
	{
		return new TSWebDrawingViewActionItem()
		{
			@Override
			public Serializable onAction(TSAbstractItemDefinition itemDef)
			{
				TSLogger.info(this.getClass(), "Placeholder view action called");
				return null;
			}


			/**
			 * Java Serialization ID.
			 */
			private static final long serialVersionUID = 1L;
		};
	}


	/**
	 * This method returns the name of the function that will be executed
	 * in the client side before any request is done to the server side.
	 * @return The name of the function.
	 */
	@Override
	public String getPreAction()
	{
		return null;
	}


	/**
	 * {@inheritDoc}
	 */
	@Override
	public boolean shouldBeEnabled(TSModelView modelView)
	{
		return true;
	}


	/**
	 * Java Serialization ID.
	 */
	private static final long serialVersionUID = 1L;
}
