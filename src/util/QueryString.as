package util
{
    import flash.external.ExternalInterface;
    public class QueryString
    {
        public function QueryString() 
		{
			
		}
	
        public static function getValue($val:String):String
        {
			var url:String = ExternalInterface.call("document.location.search.toString");
			var reg:RegExp = new RegExp("[\?\&]" + $val + "=([^\&]*)(\&?)", "i");
		    var result:Object = reg.exec(url);
			return result? result[1]:"";
			
        }    
    }
} 