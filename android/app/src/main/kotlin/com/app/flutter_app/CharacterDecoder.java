package com.app.flutter_app;

import android.util.Log;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PushbackInputStream;
import java.nio.ByteBuffer;

public abstract class CharacterDecoder
{
    public CharacterDecoder() {}

    protected abstract int bytesPerAtom();

    protected abstract int bytesPerLine();

    protected void decodeBufferPrefix(PushbackInputStream paramPushbackInputStream, OutputStream paramOutputStream)
            throws IOException
    {}

    protected void decodeBufferSuffix(PushbackInputStream paramPushbackInputStream, OutputStream paramOutputStream)
            throws IOException
    {}

    protected int decodeLinePrefix(PushbackInputStream paramPushbackInputStream, OutputStream paramOutputStream)
            throws IOException
    {
        return bytesPerLine();
    }

    protected void decodeLineSuffix(PushbackInputStream paramPushbackInputStream, OutputStream paramOutputStream)
            throws IOException
    {}

    protected void decodeAtom(PushbackInputStream paramPushbackInputStream, OutputStream paramOutputStream, int paramInt)
            throws IOException
    {
        throw new CEStreamExhausted();
    }

    protected int readFully(InputStream paramInputStream, byte[] paramArrayOfByte, int paramInt1, int paramInt2)
            throws IOException
    {
        for (int i = 0; i < paramInt2; i++)
        {
            int j = paramInputStream.read();
            if (j == -1) {
                return i == 0 ? -1 : i;
            }
            paramArrayOfByte[(i + paramInt1)] = ((byte)j);
        }
        return paramInt2;
    }

    public void decodeBuffer(InputStream paramInputStream, OutputStream paramOutputStream)
            throws IOException
    {
        int j = 0;
        PushbackInputStream localPushbackInputStream = new PushbackInputStream(paramInputStream);
        //decodeBufferPrefix(localPushbackInputStream, paramOutputStream);
        try
        {
            for (;;)
            {
                int k = decodeLinePrefix(localPushbackInputStream, paramOutputStream);
                Log.e("K = " , String.valueOf(k));
                Log.e("bytesPerAtom() = " , String.valueOf(bytesPerAtom()));
                int i = 0;
                while (i + bytesPerAtom() < k)
                {
                    decodeAtom(localPushbackInputStream, paramOutputStream, bytesPerAtom());
                    j += bytesPerAtom();
                    i += bytesPerAtom();
                }

                if (i + bytesPerAtom() == k)
                {
                    decodeAtom(localPushbackInputStream, paramOutputStream, bytesPerAtom());
                    j += bytesPerAtom();
                }
                else
                {
                    decodeAtom(localPushbackInputStream, paramOutputStream, k - i);
                    j += k - i;
                }
                decodeLineSuffix(localPushbackInputStream, paramOutputStream);
            }

        }
        catch (CEStreamExhausted localCEStreamExhausted)
        {
            decodeBufferSuffix(localPushbackInputStream, paramOutputStream);
        }
    }

    public byte[] decodeBuffer(String paramString)
            throws IOException
    {
        byte[] arrayOfByte = new byte[paramString.length()];

        paramString.getBytes(0, paramString.length(), arrayOfByte, 0);
        for(int i=0; i<arrayOfByte.length; i++)
            Log.e("param string bytes i = " + i, paramString.getBytes()[i] + "");

        ByteArrayInputStream localByteArrayInputStream = new ByteArrayInputStream(arrayOfByte);
        ByteArrayOutputStream localByteArrayOutputStream = new ByteArrayOutputStream();
        decodeBuffer(localByteArrayInputStream, localByteArrayOutputStream);


        return localByteArrayOutputStream.toByteArray();
    }

    public byte[] decodeBuffer(InputStream paramInputStream)
            throws IOException
    {
        ByteArrayOutputStream localByteArrayOutputStream = new ByteArrayOutputStream();
        decodeBuffer(paramInputStream, localByteArrayOutputStream);
        return localByteArrayOutputStream.toByteArray();
    }

    public ByteBuffer decodeBufferToByteBuffer(String paramString)
            throws IOException
    {
        return ByteBuffer.wrap(decodeBuffer(paramString));
    }

    public ByteBuffer decodeBufferToByteBuffer(InputStream paramInputStream)
            throws IOException
    {
        return ByteBuffer.wrap(decodeBuffer(paramInputStream));
    }
}