
#include "ros/ros.h"
#include <image_transport/image_transport.h>
#include <sensor_msgs/image_encodings.h>
#include <cv_bridge/cv_bridge.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/features2d.hpp>
#include <geometry_msgs/Twist.h>
#include <iostream>

#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
using namespace cv;
using namespace std;

static const std::string OPENCV_WINDOW = "Image window";

class detector
{
  ros::NodeHandle nh_;
  image_transport::ImageTransport it_;
  image_transport::Subscriber image_sub_;

  private:
    bool ParamsSet;
    cv::Mat StopImage;
    cv::Mat RightImage;
    cv::Mat LeftImage;

    // amount to multiply the pixel value of the detected block
    const int x_total = 47; // value in mm
    const int x_length_left = -(x_total/2);
    const int x_length_right = (x_total/2);
    const int y_total = 55; // value in mm
    const int y_length_left = -(y_total/2);
    const int y_length_right = (y_total/2);

  protected:
    cv::SimpleBlobDetector BLOBdetector;
    ros::Publisher object1_pub_;
    ros::Publisher object2_pub_;
  public:
    detector()
      : it_(nh_)
    {
      // Subscrive to input video feed and publish output video feed
      //image_sub_ = it_.subscribe("/camera/rgb/image_raw", 1, &detector::detectorCB, this);
      image_sub_ = it_.subscribe("/usb_cam/image_raw", 1, &detector::handCameraCB, this);
      object1_pub_ = nh_.advertise<geometry_msgs::Twist>("/object1", 1);
      object2_pub_ = nh_.advertise<geometry_msgs::Twist>("/object2", 1);
      // centreTarget_pub_ = nh_.advertise<geometry_msgs::Twist>("/centreTarget", 1);

  ////
  //// THE FOLLOWING FILE PATHS NEED TO BE CHANGED DEPENDING ON THE SYSTEM
  ////
      LeftImage = imread("/home/oscar/Documents/GitHub/Fiverr/aange77/src/detection/config/LeftEnd.png", IMREAD_GRAYSCALE);
      RightImage = imread("/home/oscar/Documents/GitHub/Fiverr/aange77/src/detection/config/RightEnd.png", IMREAD_GRAYSCALE);



      // open a window to see what the camera sees
      cv::namedWindow(OPENCV_WINDOW);

    }

    ~detector()
    {
      // if the node is killed, so is the window
      cv::destroyWindow(OPENCV_WINDOW);
    }
    cv::Mat ImagePrep(cv::Mat Image)
    {
      cv::Mat GRAYimage;
        cv::resize(Image, Image, cv::Size(480,640)); // convert to uniform size
        cv::cvtColor(Image, GRAYimage, cv::COLOR_BGR2GRAY); // gray colourspace is easier for most opencv functions
        //cv::threshold(GRAYimage, Image, 150, 250, 3);      //3: Threshold to Zero
      return GRAYimage;
    }

    void handCameraCB(const sensor_msgs::ImageConstPtr& msg)
    {
      cv_bridge::CvImagePtr cv_ptr;
      cv::Mat CurrentImage;
      try
      {
        cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGR8);  // convert from imagetransport to rosbridge pointer
        CurrentImage = cv_ptr->image;   // copy image to Mat type to use with opencv
        CurrentImage = ImagePrep(CurrentImage);

      }
      catch (cv_bridge::Exception& e)
      {
        ROS_ERROR("cv_bridge exception: %s", e.what()); // if error occurs, output to terminal
        return;
      }

      cv::Mat LeftResult, RightResult;
      double StopScore;
      cv::matchTemplate(CurrentImage, LeftImage, LeftResult, cv::TM_SQDIFF_NORMED);
      cv::matchTemplate(CurrentImage, RightImage, RightResult, cv::TM_SQDIFF_NORMED);

      double minVal, maxVal; Point minLoc, maxLoc, matchLoc;
      minMaxLoc( LeftResult, &minVal, &maxVal, &minLoc, &maxLoc);
      rectangle( CurrentImage, Point(minLoc.x, minLoc.y), Point( minLoc.x + LeftImage.cols , minLoc.y + LeftImage.rows ), Scalar(0,255,0));

      geometry_msgs::Twist object1location;
      object1location.linear.x = 0;
      object1location.linear.y = (minLoc.x + (LeftImage.cols/2)) / x_length_left;
      object1location.linear.z = (minLoc.y + (LeftImage.rows/2)) / y_length_left;
      //object1location.angular.x = ;


      cv::matchTemplate(CurrentImage, RightImage, RightResult, cv::TM_SQDIFF_NORMED);
      minMaxLoc( RightResult, &minVal, &maxVal, &minLoc, &maxLoc);
      rectangle( CurrentImage, Point(minLoc.x, minLoc.y), Point( minLoc.x + RightImage.cols , minLoc.y + RightImage.rows ), Scalar(0,255,0));

      geometry_msgs::Twist object2location;
      object2location.linear.x = 0;
      object2location.linear.y = (minLoc.x + (LeftImage.cols/2)) / x_length_right;
      object2location.linear.z = (minLoc.y + (LeftImage.rows/2)) / y_length_right;
      // //object2location.angular.x = ;

      object1_pub_.publish(object1location);
      object2_pub_.publish(object2location);


      cv::imshow(OPENCV_WINDOW, CurrentImage);    cv::waitKey(100);
    }

  void detectorCB(const sensor_msgs::ImageConstPtr& msg)
  {
    cv_bridge::CvImagePtr cv_ptr;

    try
    {
      cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGR8);  // convert from imagetransport to rosbridge pointer
      cv::resize(cv_ptr->image, cv_ptr->image, cv::Size(480,640)); // convert to uniform size
      cv::flip(cv_ptr->image, cv_ptr->image, 0); // flip to correct orientation
    }
    catch (cv_bridge::Exception& e)
    {
      ROS_ERROR("cv_bridge exception: %s", e.what()); // if error occurs, output to terminal
      return;
    }

    cv::Mat Frame = cv_ptr->image;   // copy image to Mat type to use with opencv
    Frame = cv::imread("/home/oscar/Pictures/inline.png", cv::IMREAD_GRAYSCALE);

    //std::vector<cv::KeyPoint> BlobLocations = DetectObjects(Frame);

    geometry_msgs::Twist object1location;
    geometry_msgs::Twist object2location;

    std::vector<cv::Point2f> point2f_vector; //We define vector of point2f
    //cv::KeyPoint::convert(BlobLocations, point2f_vector, std::vector< int >()); //Then we use this nice function from OpenCV to directly convert from KeyPoint vector to Point2f vector


    // object1location.linear.x = 0;
    // object1location.linear.y = point2f_vector[1].x;
    // object1location.linear.z = point2f_vector[1].y;
    // //object1location.angular.x = ;
    //
    //
    // object2location.linear.x = 0;
    // object2location.linear.y = point2f_vector[2].x;
    // object2location.linear.z = point2f_vector[2].y;
    // //object2location.angular.x = ;
    //
    // object1_pub_.publish(object1location);
    // object2_pub_.publish(object2location);
  }
};

int main(int argc, char** argv)
{
  ros::init(argc, argv, "detector");
  detector det;
  while(ros::ok())
  {
    ros::spinOnce();
  }
  return 0;
}
