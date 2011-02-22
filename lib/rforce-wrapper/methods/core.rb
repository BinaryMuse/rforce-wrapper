module RForce
  module Wrapper
    module CoreMethods

      def convertLead(*leadConverts)
      end
    
      def create(*sObjects)
      end
    
      def delete(*ids)
      end
    
      def emptyRecycleBin(*ids)
      end
    
      def getDeleted(sObjectType, startDate, endDate)
      end
    
      def getUpdated(sObjectType, startDate, endDate)
      end
    
      def invalidateSessions(*sessionIds)
      end
    
      def logout
        make_api_call :logout
      end
    
      def merge(*mergeRequests)
      end
    
      def process(*processRequests)
      end
    
      def query(queryString)
      end
    
      def queryAll(queryString)
      end
    
      def queryMore(queryLocator)
      end

      # http://www.salesforce.com/us/developer/docs/api/Content/sforce_api_calls_retrieve.htm
      def retrieve(fieldList, sObjectType, *ids)
        params = [ :fieldList, fieldList, :sObjectType, sObjectType ]
        params += ids.flatten.map { |id| [:Id, id] }.flatten
        make_api_call :retrieve, params
      end

      def search(searchString)
      end
    
      def undelete(*ids)
      end
    
      def update(*sObjects)
      end
    
      def upsert(externalIdFieldName, *sObjects)
      end

    end
  end
end
