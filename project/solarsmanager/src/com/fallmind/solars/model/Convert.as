package com.fallmind.solars.model
{
	
	
	import mx.formatters.DateFormatter;
	public class Convert extends DateFormatter{
	/**
	 * 将字符串转换为Date类型
	 * @param str 日期字符串
	 * @return Date类型的值
	 */
    public static function convertToDate(str:String):Date{
       	return DateFormatter.parseDateString(str);
    }
    
}
}