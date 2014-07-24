package com.fallmind.solars.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class StartupCommand extends MacroCommand
	{
		/**
		 * 初始化Model 和 View
		 */
		override protected function initializeMacroCommand() :void
        {
            // ModelPrepCommand 先执行，然后再执行 ViewPrepCommand
            addSubCommand( ModelPrepCommand );
            addSubCommand( ViewPrepCommand );
            addSubCommand( GetCompanyListCommand );
        }
       
	}
}