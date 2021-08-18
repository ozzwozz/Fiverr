
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

  void detectorCB (constdetectorCB sensor_msgs::ImageConstPtr& msg)
  {

    cv_bridge::CvImagePtr cv_ptr;

    try
    {
      cv_ptr = cv_bridge::toCvCopy(msg, sensor_msgs::image_encodings::BGR8);  // convert from imagetransport to rosbridge pointer
      cv::resize(cv_ptr->image, cv_ptr->image, Size(1080,720)); // convert to uniform size
      cv::flip(cv_ptr->image, cv_ptr->image, 0); // flip to correct orientation
    }
    catch (cv_bridge::Exception& e)
    {
      ROS_ERROR("cv_bridge exception: %s", e.what()); // if error occurs, output to terminal
      return;
    }

    cv::Mat Frame = cv_ptr->image;   // copy image to Mat type to use with opencv

    cv::vector<cv::Point> BlobLocations = DetectObjects(Frame);


    object1_pub_.publish(object1location);
    object2_pub_.publish(object2location);
  }

  cv::vector<cv::Point> detector::DetectObjects(cv::Mat Frame)
  {
    SimpleBlobDetector::Params params;
    params.minThreshold = 10;
    params.maxThreshold = 10;

    params.filterByArea = true;
    params.minArea = 1500;

    params.filterByCircularity = true;
    params.minCircularity = 0.1;

    params.filterByConvexity = true;
    params.minConvexity = true;

    params.filterByInertia = true;
    params.minConvexity = 0,01;

    SimpleBlobDetector BlobDetect(params);

    Ptr<SimpleBlobDetector> BlobDetect = SimpleBlobDetector::create(params);

    cv::imshow(OPENCV_WINDOW, BlobDetect);

  }
};

int main(int argc, char** argv)
{
  ros::init(argc, argv, "detector");
  detector ic;
  while(ros::ok())
  {
    ros::spinOnce();
  }
  return 0;
}
