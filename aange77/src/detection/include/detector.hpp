#include <ros/ros.h>
#include <image_transport/image_transport.h>
#include <sensor_msgs/image_encodings.h>
#include <cv_bridge/cv_bridge.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

static const std::string OPENCV_WINDOW = "Image window";

class detector()
{
  ros::NodeHandle nh_;
  image_transport::ImageTransport it_;
  image_transport::Subscriber image_sub_;

  private:
  protected:
    cv::SimpleBlobDetector BLOBdetector;

  public:
    detector()
      : it_(nh_)
    {
      // Subscrive to input video feed and publish output video feed
      image_sub_ = it_.subscribe("/camera/rgb/image_raw", 1, &detector::detectorCB, this);

      ros::Publisher object1_pub_ = nh_.advertise<geometry_msgs::Twist>("/object1", 1);
      ros::Publisher object2_pub_ = nh_.advertise<geometry_msgs::Twist>("/object2", 1);
      // centreTarget_pub_ = nh_.advertise<geometry_msgs::Twist>("/centreTarget", 1);

      // open a window to see what the camera sees
      cv::namedWindow(OPENCV_WINDOW);

    }

    ~detector()
    {
      // if the node is killed, so is the window
      cv::destroyWindow(OPENCV_WINDOW);
    }

}
