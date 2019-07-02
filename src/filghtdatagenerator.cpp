#include "filghtdatagenerator.h"





// default data
FlightData::Generator::FlightDataGenerator::FlightDataGenerator(const QGeoCoordinate& firstPos,
    const QGeoCoordinate& lastPos, QObject* parent): QObject(parent), weatherTimer(new QTimer(this)),
    flyData{firstPos,firstPos,lastPos,0.0,0.0, firstPos.distanceTo(lastPos)/Data::Param::KM},
    weatherData{"02d",20,30,6.5,""} {
    connect(weatherTimer, &QTimer::timeout, this,&FlightDataGenerator::weatherDataGenerator);

    weatherTimer->setInterval(2*60*1000);
    weatherTimer->start();

    //qDebug() << flyData.startPoint.distanceTo(flyData.endPoint) /1000;
}

// Descript:

// firstPos -> Cracow
// lastPos  -> Gdansk


// FlyData{
//    QGeoCoordinate lastPosition          < - last known position
//    QGeoCoordinate startPoint, endPoint  < - start and end point(Cracow/Gdansk)
//    double alt
//    double speed
//    double distanceToGoal
// }

// WeatherData{
//    int iconID
//    double temp
//    double humidity
//    double windSpeed
//    QString description
// }

template<typename T>
T FlightData::Generator::numberGenerator(T a, T b){
    if(typeid(T) == typeid(int)){
        std::uniform_int_distribution<int> intDist(a,b);
        return intDist(*QRandomGenerator::global());
    }
    else if(typeid(T) == typeid(double)){
        std::uniform_real_distribution<double> doubleDist(a,b);
        return doubleDist(*QRandomGenerator::global());
    }
    else
        throw(QString("Undefinied type of template."));
}

void FlightData::Generator::FlightDataGenerator::setPoint(const QGeoCoordinate& point){
    if(flyData.lastPosition == point)
        return;

    flyData.lastPosition = point;

    if(flyData.lastPosition == flyData.endPoint)
        std::swap(flyData.startPoint, flyData.endPoint);

    setDistanceToPoint(flyData.lastPosition);

    emit movePosition();  // emit signal about moving position
}

void FlightData::Generator::FlightDataGenerator::setDistanceToPoint(const QGeoCoordinate& point){
    if(!point.isValid())
        return;

    flyData.distanceToGoal = static_cast<double>(point.distanceTo(flyData.endPoint)) / Data::Param::KM;
}

void FlightData::Generator::FlightDataGenerator::weatherDataGenerator(){
    auto render([](auto a, auto b){ return std::uniform_int_distribution<int>(a,b); });

    try{
        weatherData.temp = numberGenerator(21,24);      // Celcius
        qDebug()<<"Temperature: "<<weatherData.temp;

        auto h(QTime::currentTime().hour());

        if(h >= 20 || (h >= 1 && h <= 5))
            weatherData.iconID = "02n";            // evening/night
        else{
            if(h > 5 && h <= 14)
                weatherData.iconID = "02d";        // day
            else
                weatherData.iconID = "01d";
        }
        qDebug()<<"IconID: "<<weatherData.iconID;

        weatherData.humidity = numberGenerator(30,33);  // %
        qDebug()<<"Humidity: "<<weatherData.humidity;

        weatherData.windSpeed = numberGenerator(4.0,10.0);  // m/s
        qDebug()<<"WindSpeed: "<< round(weatherData.windSpeed*10)/10;

        emit weatherSignal();
    }
    catch(const QString& e){
        qDebug() << e;
    }
}
