package vo
{
	public class Config
	{
		public static var Language:String="en_US";
		public static var StationId:String="";
		public static var UserId:String="";
		public static var ISNO:String="";
		public static var BaseUrl:String="";
		public function Config()
		{
		}
		
		/**
		 *读取dcp数据 
		 * @return 
		 * 
		 */	
		public static function get GetDCPData():String{
			return BaseUrl+"swfdcp.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取dcc数据 
		 * @return 
		 * 
		 */	
		public static function get GetDCCData():String{
			return BaseUrl+"swfdcc.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取dcv数据 
		 * @return 
		 * 
		 */	
		public static function get GetDCVData():String{
			return BaseUrl+"swfdcv.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取acp数据 
		 * @return 
		 * 
		 */	
		public static function get GetACPData():String{
			return BaseUrl+"swfacp.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取acc数据 
		 * @return 
		 * 
		 */	
		public static function get GetACCData():String{
			return BaseUrl+"swfacc.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取acf数据 
		 * @return 
		 * 
		 */	
		public static function get GetACFData():String{
			return BaseUrl+"swfacf.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取acv数据 
		 * @return 
		 * 
		 */	
		public static function get GetACVData():String{
			return BaseUrl+"swfacv.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取invtemp数据 
		 * @return 
		 * 
		 */	
		public static function get GetTempData():String{
			return BaseUrl+"swfinvtemp.action?isno="+ISNO+"&type=";
		}
		
		/**
		 *读取income数据 
		 * @return 
		 * 
		 */	
		public static function get GetIncomeData():String{
			return BaseUrl+"swfincome.action?stationid="+StationId+"&type=";
		}
		
		/**
		 *读取co2av数据 
		 * @return 
		 * 
		 */	
		public static function get GetCo2avData():String{
			return BaseUrl+"swfco2av.action?stationid="+StationId+"&type=";
		}
		
		/**
		 *读取overview数据 
		 * @return 
		 * 
		 */	
		public static function get GetOverViewData():String{
			return BaseUrl+"getStationInfo?sid="+StationId;//"data/1.txt";
		}
		
		//恢复并获取系统默认图片的接口url
		public static function get GetDefaultBgUrl():String {
			return BaseUrl + "modifyStationBg?sid=" + StationId;
		}
		
		/**
		 *读取Power数据 
		 * @return 
		 * 
		 */	
		public static function get GetPowerData():String{
			return BaseUrl+"stationAmountInfo?sid="+StationId+"&type=";//"data/1.txt";//
		}
		
		/**
		 *上传overview背景图 
		 * @return 
		 * 
		 */	
		public static function get FileUploadUrl():String{
			return BaseUrl+"fileUpload?sid="+StationId;
		}
		
	}
}