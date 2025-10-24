import { KibanaDashboard } from '@/components/dashboard/KibanaDashboard'
import { FivetranStatus } from '@/components/dashboard/FivetranStatus'
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

export default function AnalyticsPage() {
  return (
    <div className="container mx-auto p-6">
      <Tabs defaultValue="kibana" className="space-y-4">
        <TabsList>
          <TabsTrigger value="kibana">Kibana Analytics</TabsTrigger>
          <TabsTrigger value="fivetran">Fivetran Pipeline</TabsTrigger>
        </TabsList>
        
        <TabsContent value="kibana" className="space-y-4">
          <KibanaDashboard />
        </TabsContent>
        
        <TabsContent value="fivetran" className="space-y-4">
          <FivetranStatus />
        </TabsContent>
      </Tabs>
    </div>
  )
}

