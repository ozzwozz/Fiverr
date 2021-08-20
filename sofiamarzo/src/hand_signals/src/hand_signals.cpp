#include "ros/ros.h"
#include <image_transport/image_transport.h>
#include <sensor_msgs/image_encodings.h>
#include <cv_bridge/cv_bridge.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/features2d.hpp>
#include <geometry_msgs/Twist.h>
#include <iostream>

static const std::string OPENCV_WINDOW = "Image window";

class hand_signals
{
  ros::NodeHandle nh_;
  image_transport::ImageTransport it_;
  image_transport::Subscriber image_sub_;

  private:
    bool ParamsSet;

  protected:
    ros::Publisher object1_pub_;

    cv::Mat StopImage;
    cv::Mat ForwardImage;
    cv::Mat LeftImage;
    cv::Mat RightImage;

    geometry_msgs::Twist object1location;

  public:
    hand_signals()
      : it_(nh_)
    {
      // Subscrive to input video feed and publish output video feed
      image_sub_ = it_.subscribe("/usb_cam/image_raw", 1, &hand_signals::handCameraCB, this);
      object1_pub_ = nh_.advertise<geometry_msgs::Twist>("/robo_Twist", 1);

      StopImage = cv::imread("/home/oscar/Documents/GitHub/Fiverr/sofiamarzo/src/hand_signals/config/st.png");
      ForwardImage = cv::imread("/home/oscar/Documents/GitHub/Fiverr/sofiamarzo/src/hand_signals/config/fw.png");
      LeftImage = cv::imread("/home/oscar/Documents/GitHub/Fiverr/sofiamarzo/src/hand_signals/config/l.png");
      RightImage = cv::imread("/home/oscar/Documents/GitHub/Fiverr/sofiamarzo/src/hand_signals/config/r.png");

      StopImage = ImagePrep(StopImage);
      ForwardImage = ImagePrep(ForwardImage);
      LeftImage = ImagePrep(LeftImage);
      RightImage = ImagePrep(RightImage);


      // open a window to see what the camera sees
      cv::namedWindow(OPENCV_WINDOW);


    }

    ~hand_signals()
    {
      // if the node is killed, so is the window
      //cv::destroyWindow(OPENCV_WINDOW);
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
      cv::Mat Frame = cv_ptr->image;   // copy image to Mat type to use with opencv
      CurrentImage = ImagePrep(Frame);
    }
    catch (cv_bridge::Exception& e)
    {
      ROS_ERROR("cv_bridge exception: %s", e.what()); // if error occurs, output to terminal
      return;
    }

    //cv::compare(master, current, a);
    cv::Mat StopResult, ForwardResult, LeftResult, RightResult;
    double StopScore, ForwardScore, LeftScore, RightScore;
    cv::matchTemplate(CurrentImage, StopImage, StopResult, cv::TM_SQDIFF_NORMED);
    cv::matchTemplate(CurrentImage, ForwardImage, ForwardResult, cv::TM_SQDIFF_NORMED);
    cv::matchTemplate(CurrentImage, LeftImage, LeftResult, cv::TM_SQDIFF_NORMED);
    cv::matchTemplate(CurrentImage, RightImage, RightResult, cv::TM_SQDIFF_NORMED);

    cv::minMaxLoc(StopResult, 0, &StopScore);
    cv::minMaxLoc(ForwardResult, 0, &ForwardScore);
    cv::minMaxLoc(LeftResult, 0, &LeftScore);
    cv::minMaxLoc(RightResult, 0, &RightScore);


    ROS_ERROR("StopScore %f", StopScore);
    ROS_ERROR("ForwardScore %f", ForwardScore);
    ROS_ERROR("LeftScore %f", LeftScore);
    ROS_ERROR("RightScore %f", RightScore);

    if (StopScore < ForwardScore && StopScore < LeftScore && StopScore < RightScore)
    {
      MoveStop();
    }
    else if (ForwardScore < StopScore && ForwardScore < LeftScore && ForwardScore < RightScore)
    {
      MoveForward();
    }
    else if (LeftScore < StopScore && LeftScore < ForwardScore && LeftScore < RightScore)
    {
      MoveLeft();
    }
    else if (RightScore < StopScore && RightScore < ForwardScore && RightScore < LeftScore)
    {
      MoveRight();
    }

    cv::imshow(OPENCV_WINDOW, CurrentImage);    cv::waitKey(100);

  }

  void MoveForward()
  {
    object1location.linear.x = 1;
    object1location.linear.y = 0;

    object1_pub_.publish(object1location);
  }

  void MoveStop()
  {
    object1location.linear.x = 0;
    object1location.linear.y = 0;

    object1_pub_.publish(object1location);
  }

  void MoveLeft()
  {
    object1location.linear.x = 0;
    object1location.angular.x = -1;

    object1_pub_.publish(object1location);
  }

  void MoveRight()
  {
    object1location.linear.x = 0;
    object1location.angular.x = 1;

    object1_pub_.publish(object1location);
  }

};

int main(int argc, char** argv)
{
  ros::init(argc, argv, "hand_signals");
  hand_signals hand_sig;

  while(ros::ok())
  {
    ros::spin();
  }
  return 0;
}
