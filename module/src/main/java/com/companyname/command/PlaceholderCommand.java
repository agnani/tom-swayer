package com.companyname.command;


import com.tomsawyer.canvas.TSViewportCanvas;
import com.tomsawyer.util.gwtclient.command.TSServiceCommand;
import com.tomsawyer.util.shared.TSServiceException;
import com.tomsawyer.view.TSModelView;
import com.tomsawyer.view.drawing.TSModelDrawingView;
import com.tomsawyer.web.client.command.TSCustomCommand;
import com.tomsawyer.web.server.TSProjectSessionInfo;
import com.tomsawyer.web.server.command.TSServiceCommandImpl;
import com.tomsawyer.web.server.service.TSPerspectivesViewService;
import java.io.Serializable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;


/**
 * This class is the action command to load the json data.
 */
public class PlaceholderCommand implements TSServiceCommandImpl
{
	@Override
	public Serializable doAction(
		TSPerspectivesViewService tsPerspectivesViewService,
		TSServiceCommand tsServiceCommand) throws TSServiceException
	{
		TSCustomCommand customCommand = (TSCustomCommand) tsServiceCommand;

		TSProjectSessionInfo projectInfo =
			tsPerspectivesViewService.getProjectSessionInfo(customCommand.getProjectID());
		TSModelView view = projectInfo.getView(customCommand.getViewID());

		List<String> argumentList = customCommand.getCustomArgs();

		if (argumentList == null || argumentList.isEmpty())
		{
			throw new TSServiceException("No arguments found for the save image action");
		}

		String fileName = argumentList.get(0);
		String fileTypeId = argumentList.get(1);
		String visibleOnly = argumentList.get(2);
		String selectedOnly = argumentList.get(3);
		String sizeID = argumentList.get(4);
		String width = argumentList.get(5);
		String height = argumentList.get(6);
		String pixelRatio = argumentList.get(7);
		String viewId = argumentList.get(8);

		TSViewportCanvas canvas =
			((TSModelDrawingView) view).getCanvas();

		double zoomLevel = canvas.getZoomLevel();

		HttpServletRequest request = tsPerspectivesViewService.getRequest();
		String url = request.getRequestURL().toString();
		String baseURL =
			url.substring(
				0,
				url.length() - request.getRequestURI().length()) +
				request.getContextPath() + "/";

		String servletURL =
			baseURL +
				"tsperspectives/" +
				"TSSaveImage?" +
				"projectID=" + customCommand.getProjectID() +
				"&viewID=" + viewId +
				"&fileName=" + fileName +
				"&typeId=" + fileTypeId +
				"&visibleOnly=" + visibleOnly +
				"&selectedOnly=" + selectedOnly +
				"&sizeID=" + sizeID +
				"&width=" + width +
				"&height=" + height +
				"&currentZoom=" + zoomLevel +
				"&pixelRatio=" + pixelRatio;

		return servletURL;
	}
}
