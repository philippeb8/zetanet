/**
    Copyright 2019 Fornux Inc.

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#ifndef IMAGEPROVIDER_H
#define IMAGEPROVIDER_H

#include <QThreadPool>
#include <QQuickImageProvider>

template <typename T>
    class AsyncImageResponse : public QQuickImageResponse, public QRunnable
    {
    public:
        typedef QVariant (T::* RequestType)(int id) const;

        AsyncImageResponse(T const & sql, RequestType query, const QString &id, const QSize &requestedSize)
            : sql(sql)
            , query(query)
            , id(id)
            , requestedSize(requestedSize)
        {
            setAutoDelete(false);
        }

        QQuickTextureFactory *textureFactory() const
        {
            return QQuickTextureFactory::textureFactoryForImage(image);
        }

        void run()
        {
            image.loadFromData((sql.*query)(id.toInt()).toByteArray());

            if (requestedSize.isValid())
                image = image.scaled(requestedSize);

            emit finished();
        }

        T const & sql;
        RequestType query;
        QString id;
        QSize requestedSize;
        QImage image;
    };

template <typename T>
    class ImageProvider : public QQuickAsyncImageProvider
    {
    public:
        typedef typename AsyncImageResponse<T>::RequestType RequestType;

        ImageProvider(T const & sql, RequestType query)
          : sql(sql)
          , query(query)
        {
        }

        QQuickImageResponse *requestImageResponse(const QString &id, const QSize &requestedSize)
        {
            AsyncImageResponse<T> *response = new AsyncImageResponse<T>(sql, query, id, requestedSize);
            pool.start(response);
            return response;
        }

    private:
        T const & sql;
        RequestType query;
        QThreadPool pool;
    };

#endif // IMAGEPROVIDER_H
