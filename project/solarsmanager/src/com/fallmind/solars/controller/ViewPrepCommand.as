package com.fallmind.solars.controller
{
	import com.fallmind.solars.view.ApplicationMediator;

	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	/**
	 * 视图的工厂，实例化视图类
	 */
	public class ViewPrepCommand extends SimpleCommand
	{
		override public function execute( note:INotification ) :void    
        {            
            facade.registerMediator(new ApplicationMediator(note.getBody())); 
        }

	}
}