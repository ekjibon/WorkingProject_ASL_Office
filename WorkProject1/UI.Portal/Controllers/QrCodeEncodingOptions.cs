namespace UI.Portal.Controllers
{
    internal class QrCodeEncodingOptions
    {
        public string CharacterSet { get; set; }
        public bool DisableECI { get; set; }
        public int Height { get; set; }
        public bool PureBarcode { get; set; }
        public int Width { get; set; }
    }
}