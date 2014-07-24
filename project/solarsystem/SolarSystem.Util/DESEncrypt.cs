using System;
using System.Security.Cryptography;
using System.Text;
using System.IO;
namespace SolarSystem.Utils
{
    /// <summary>
    /// DES加密/解密类。
    /// </summary>
    public sealed class DESEncrypt
    {
        private DESEncrypt()
        {
        }
        private static string keystr = "StuMSYBQ";//这个必须是8位字符
        /// <summary>
        /// 加密
        /// </summary>
        /// <param name="datastr">要加密的字符串</param>
        /// <param name="keystr">机密密钥</param>
        /// <returns>加密后的字符串</returns>
        public static String Encrypt(String datastr)
        {
            DESCryptoServiceProvider desc = new DESCryptoServiceProvider();//des进行加密

            byte[] key = System.Text.Encoding.ASCII.GetBytes(keystr);
            byte[] data = System.Text.Encoding.Unicode.GetBytes(datastr);

            MemoryStream ms = new MemoryStream();//存储加密后的数据
            CryptoStream cs = new CryptoStream(ms, desc.CreateEncryptor(key, key), CryptoStreamMode.Write);

            cs.Write(data, 0, data.Length);//进行加密
            cs.FlushFinalBlock();

            return System.Convert.ToBase64String(ms.ToArray());//取加密后的数据
        }

        /// <summary>
        /// 解密
        /// </summary>
        /// <param name="datastr">要解密的字符串</param>
        /// <param name="keystr">机密密钥</param>
        /// <returns>解密后的字符串</returns>
        public static String Decrypt(String datastr)
        {
            byte[] data = System.Convert.FromBase64String(datastr);

            DESCryptoServiceProvider desc = new DESCryptoServiceProvider();

            byte[] key = System.Text.Encoding.ASCII.GetBytes(keystr);

            MemoryStream ms = new MemoryStream();//存储解密后的数据
            CryptoStream cs = new CryptoStream(ms, desc.CreateDecryptor(key, key), CryptoStreamMode.Write);

            cs.Write(data, 0, data.Length);//解密数据
            cs.FlushFinalBlock();

            return System.Text.Encoding.Unicode.GetString(ms.ToArray());
        }
    }
}
